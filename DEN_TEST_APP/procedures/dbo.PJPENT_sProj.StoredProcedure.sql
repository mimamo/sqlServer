USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENT_sProj]    Script Date: 12/21/2015 15:37:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENT_sProj] @parm1 varchar (16)   as
Select * from PJPENT
where PJPENT.project =  @parm1
GO
