import Pkg, GracefulPkg
Pkg.activate("test/fixtures/dyad")
# Should remove compats and work
report = GracefulPkg.addname("ModelingToolkitTolerances")
@info "Report" [(k.strategy => k.success) for k in report.strategy_reports]