USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_sunpco]    Script Date: 12/21/2015 14:34:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVHDR_sunpco] @parm1 varchar (16) , @parm2 varchar (16)  as
SELECT  *    from PJREVHDR
WHERE       project = @parm1 and
change_order_num = @parm2 and
status <> 'P'
GO
