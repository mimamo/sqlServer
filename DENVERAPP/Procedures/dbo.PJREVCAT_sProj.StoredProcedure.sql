USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_sProj]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_sProj] @parm1 varchar (16)   as
Select * from PJREVCAT
WHERE       pjrevcat.project = @parm1
GO
