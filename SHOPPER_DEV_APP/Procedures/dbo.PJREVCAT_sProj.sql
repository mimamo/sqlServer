USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_sProj]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_sProj] @parm1 varchar (16)   as
Select * from PJREVCAT
WHERE       pjrevcat.project = @parm1
GO
