USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJvTran_sFiscal]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJvTran_sFiscal]  @parm1 char (6)   as
select * from PJVTRAN
where    fiscalno < @parm1
GO
