USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTranex_delete]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJTranex_delete] @parm1 varchar (06)  as
Delete from PJTranex
where fiscalno <= @parm1
GO
