USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJACTSUM_delete]    Script Date: 12/21/2015 16:13:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACTSUM_delete] @parm1 varchar (04) as
Delete from PJACTSUM
WHERE
fsyear_num <= @parm1
GO
