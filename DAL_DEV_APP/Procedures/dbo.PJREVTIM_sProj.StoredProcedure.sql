USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTIM_sProj]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTIM_sProj] @parm1 varchar (16)  as
Select * from PJREVTIM
WHERE      project = @parm1
GO
