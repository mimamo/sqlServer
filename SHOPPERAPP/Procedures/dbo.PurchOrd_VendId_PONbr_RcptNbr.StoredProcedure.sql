USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PurchOrd_VendId_PONbr_RcptNbr]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PurchOrd_VendID_PONbr_RcptNbr    Script Date: 5/24/99 12:19:54 PM ******/
Create Proc [dbo].[PurchOrd_VendId_PONbr_RcptNbr] @parm1 varchar ( 15), @parm2 varchar ( 10) as
Select o.*, v.*
    from PurchOrd o
    left outer join
	(select distinct r.* from poreceipt r inner join potran t on t.rcptnbr = r.rcptnbr) v on v.ponbr = o.ponbr
    Where o.VendId = @parm1
      And o.PONbr Like @parm2
    Order by o.PONbr, v.Rcptnbr
GO
