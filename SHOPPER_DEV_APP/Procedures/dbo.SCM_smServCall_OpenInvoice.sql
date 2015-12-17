USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_smServCall_OpenInvoice]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_smServCall_OpenInvoice] @InvtId VarChar(30)

As

Select top 1 h.*
from smservcall h join smservdetail d on h.ServiceCallID = d.ServiceCallID
where d.invtid = @InvtId
and h.Invoicestatus = 'O'
GO
