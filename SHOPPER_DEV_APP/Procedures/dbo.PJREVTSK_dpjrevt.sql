USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_dpjrevt]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_dpjrevt] @parm1 varchar (16) , @parm2 varchar (4) , @parm3 varchar (32)  as
Delete  from PJREVTSK
WHERE       project = @parm1 and
revid = @parm2 and
pjt_entity = @parm3
GO
