USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_sProj]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_sProj] @parm1 varchar (16)  as
Select * from PJREVTSK
WHERE       PJREVTSK.project = @parm1
GO
