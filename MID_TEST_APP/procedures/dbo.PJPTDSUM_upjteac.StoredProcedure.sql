USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_upjteac]    Script Date: 12/21/2015 15:49:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_upjteac] @parm1 varchar (16)   as
Update PJPTDSUM
SET eac_amount = 0,
eac_units = 0
WHERE
project = @parm1
GO
