select * from APTran where ProjectID = '04508912agy'

select top 10 * from PurchOrd where ProjectID = '04508912agy'

select a.VouchStage, a.PONbr, a.*, b.* from PurOrdDet a, PurchOrd b where a.PONbr = b.PONbr and a.ProjectID IN ('04508912agy','04546012agy')