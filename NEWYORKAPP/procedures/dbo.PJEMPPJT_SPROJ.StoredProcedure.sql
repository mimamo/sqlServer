USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJEMPPJT_SPROJ]    Script Date: 12/21/2015 16:01:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJEMPPJT_SPROJ]  @parm1 varchar (16)   as
select * from PJEMPPJT
where    project     =   @parm1
GO
