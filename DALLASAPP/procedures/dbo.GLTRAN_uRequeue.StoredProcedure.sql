USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[GLTRAN_uRequeue]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[GLTRAN_uRequeue]  @parm1 varchar (6)  as
update GLTRAN
set pc_status = '1'
where
GLTRAN.perpost =  @parm1  and
GLTRAN.pc_status =  '9'
GO
