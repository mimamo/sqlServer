USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMSUM_delete]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMSUM_delete] @parm1 varchar (04) as
Delete from PJCOMSUM
WHERE
fsyear_num <= @parm1
GO
