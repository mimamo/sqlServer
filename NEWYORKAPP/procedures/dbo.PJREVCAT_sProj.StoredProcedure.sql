USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_sProj]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_sProj] @parm1 varchar (16)   as
Select * from PJREVCAT
WHERE       pjrevcat.project = @parm1
GO
