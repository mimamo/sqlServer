USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_sProj]    Script Date: 12/21/2015 14:06:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_sProj] @parm1 varchar (16)  as
Select * from PJREVTSK
WHERE       PJREVTSK.project = @parm1
GO
