USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGD_delete]    Script Date: 12/21/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGD_delete] @parm1 varchar (10) as
Delete from PJCHARGD
WHERE
batch_id = @parm1
GO
