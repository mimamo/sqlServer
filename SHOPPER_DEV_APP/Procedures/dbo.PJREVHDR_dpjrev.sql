USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_dpjrev]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVHDR_dpjrev] @parm1 varchar (16) , @parm2 varchar (4)  as
Delete  from PJREVHDR
WHERE       PJREVHDR.project = @parm1 and
PJREVHDR.revid = @parm2
GO
