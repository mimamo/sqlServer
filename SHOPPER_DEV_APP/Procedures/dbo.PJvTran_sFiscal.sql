USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJvTran_sFiscal]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJvTran_sFiscal]  @parm1 char (6)   as
select * from PJVTRAN
where    fiscalno < @parm1
GO
