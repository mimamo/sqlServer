USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SPROJ]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_SPROJ]  @parm1 varchar (16)   as
select * from PJPAYHDR
where
PJPAYHDR.project    =    @parm1
GO
