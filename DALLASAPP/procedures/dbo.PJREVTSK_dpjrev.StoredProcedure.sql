USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_dpjrev]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_dpjrev] @parm1 varchar (16) , @parm2 varchar (4)  as
Delete  from PJREVTSK
WHERE       PJREVTSK.project = @parm1 and
PJREVTSK.revid = @parm2
GO
