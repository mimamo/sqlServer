USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTranex_delete]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[PJTranex_delete] @parm1 varchar (06)  as
Delete from PJTranex
where fiscalno <= @parm1
GO
