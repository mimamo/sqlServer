USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTran_delete]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJTran_delete] @parm1 varchar (06)  as
Delete from Pjtran
where
fiscalno <= @parm1 and
tr_status <> 'S'
GO
