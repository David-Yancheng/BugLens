/**
 * @name General kernel buffer overflow from IOCTL argument
 * @description A write to a buffer using an index or offset derived from an
 * IOCTL argument can cause a kernel buffer overflow, allowing an attacker with
 * access to the device file to write to arbitrary memory locations.
 * @kind path-problem
 * @id cpp/ioctl-to-general-overflow
 * @severity error
 * @precision high
 * @tags security
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import Flow::PathGraph

/**
 * A DataFlow configuration that tracks tainted data from an IOCTL `arg`
 * parameter to a memory write location (array index or pointer offset).
 */
module TaintedIndexFromIoctlConfig implements DataFlow::ConfigSig {
  /**
   * Defines the source of tainted data as the `arg` parameter of an IOCTL function.
   */
  predicate isSource(DataFlow::Node source) {
    exists(Function f, Parameter p |
      f = source.getFunction() and
      f.getName().matches("%ioctl") and
      not f.getName().matches("%compat%") and
      f.getNumberOfParameters() = 3 and 
      p.getName() = "arg"
    )
  }

  /**
   * Defines the sink as any memory write where the destination address
   * is calculated using the tainted data.
   */
  predicate isSink(DataFlow::Node sink) {
    exists(AssignExpr assign |
      // Sink 2: Tainted offset in pointer arithmetic for a write, e.g., *(ptr + tainted) = x;
      exists(PointerDereferenceExpr deref |
        deref = assign.getLValue() and
        // FIXED: The recursive predicate is getAChild*(), not getAChildExpr*().
        sink.asExpr() = deref.getAnOperand().getAChild*()
      )
    )
  }

  /**
   * Defines additional flow steps, such as through struct fields, which is common
   * when processing IOCTL arguments.
   */
  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    // Flow through field access, e.g., from `my_struct` to `my_struct.field`
    exists(FieldAccess fa |
      n1.asExpr() = fa.getQualifier() and
      n2.asExpr() = fa
    )
  }
}

// Create the data flow analysis using the configuration.
module Flow = DataFlow::Global<TaintedIndexFromIoctlConfig>;

// Import the path graph module to be able to print the flow paths.
import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "A tainted value from an IOCTL argument reaches this memory access. The value originates $@.",
  source.getNode(), "here"