USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTRAN_uRequeue]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PRTRAN_uRequeue]  @parm1 varchar (6)  as
update PRTRAN
set pc_status = '1'
where
PRTRAN.perpost =  @parm1  and
PRTRAN.pc_status =  '9'
GO
