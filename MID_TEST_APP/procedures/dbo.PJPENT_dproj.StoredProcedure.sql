USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_dproj]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_dproj] @parm1 varchar (16)   as
delete from PJPENT
where PJPENT.project =  @parm1
GO
