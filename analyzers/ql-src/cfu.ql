/**
 * @kind path-problem
 * @id cpp/ioctl-to-cfu
 * @severity warning
 */

import semmle.code.cpp.dataflow.new.DataFlow
import Flow::PathGraph
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis


predicate safeKzallocCopyFromUser(FunctionCall copyCall) {
  // Match calls to copy_from_user
  copyCall.getTarget().hasName("copy_from_user") and
  
  exists(
    FunctionCall kzallocCall, 
    Variable allocatedVar, 
    Expr sizeExpr
  |
    // Find kzalloc call
    kzallocCall.getTarget().hasName("kzalloc") and

    // The kzalloc result is assigned to a variable
    allocatedVar.getAnAssignedValue() = kzallocCall and
    
    // The first argument of copy_from_user is the allocated variable
    copyCall.getArgument(0).(VariableAccess).getTarget() = allocatedVar and
    
    // The size expressions match between kzalloc and copy_from_user
    sizeExpr = kzallocCall.getArgument(0) and
    copyCall.getArgument(2).(VariableAccess).getTarget() = sizeExpr.(VariableAccess).getTarget()
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Function f, Parameter p |
      f = source.getFunction() and
      f.getName().matches("%ioctl") and
      not f.getName().matches("%compat%") and
      f.getNumberOfParameters() = 3 and 
      p.getName() = "arg"
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call, Expr sizeArg |
      call.getTarget().getName() = "copy_from_user" and
      not safeKzallocCopyFromUser(call) and
      sizeArg = call.getArgument(2) and
      sizeArg = sink.asExpr() and
      not sizeArg.isConstant() and
      not exists(LocalScopeVariable v, int destSize |
        destSize = v.getType().getSize() and
        0 <= lowerBound(sizeArg) and
        upperBound(sizeArg) <= destSize
      )
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(FieldAccess fa |
      n1.asIndirectExpr() = fa.getQualifier() and
      n2.asExpr() = fa
    )
  }
}

module Flow = DataFlow::Global<Config>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "unsafe copy_from_user call at $@", 
  source, source.getNode().getFunction() + " " + source.getNode().getLocation().getStartLine()
  