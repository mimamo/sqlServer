USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDSUM_delete]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDSUM_delete] @parm1 varchar (04) as
Delete from PJBUDSUM
WHERE
fsyear_num <= @parm1
GO
