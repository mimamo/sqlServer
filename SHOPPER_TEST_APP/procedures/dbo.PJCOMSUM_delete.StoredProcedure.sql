USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMSUM_delete]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMSUM_delete] @parm1 varchar (04) as
Delete from PJCOMSUM
WHERE
fsyear_num <= @parm1
GO
