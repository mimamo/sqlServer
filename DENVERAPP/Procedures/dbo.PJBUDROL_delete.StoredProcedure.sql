USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDROL_delete]    Script Date: 12/21/2015 15:43:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDROL_delete] @parm1 varchar (04) as
Delete from PJBUDROL
WHERE
fsyear_num <= @parm1
GO
