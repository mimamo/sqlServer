USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_upjteac]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDROL_upjteac] @parm1 varchar (16)   as
Update PJPTDROL
SET eac_amount = 0,
eac_units = 0
WHERE
project = @parm1
GO
