USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMSUM_delete]    Script Date: 12/21/2015 15:43:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMSUM_delete] @parm1 varchar (04) as
Delete from PJCOMSUM
WHERE
fsyear_num <= @parm1
GO
