USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEX_dproj]    Script Date: 12/21/2015 14:06:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEX_dproj] @parm1 varchar (16)   as
delete from PJPENTEX
where PJPENTEX.project =  @parm1
GO
