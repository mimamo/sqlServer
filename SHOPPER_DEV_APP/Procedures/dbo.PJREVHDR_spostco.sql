USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_spostco]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVHDR_spostco] @parm1 varchar (16) , @parm2 varchar (16)  as
SELECT  *    from PJREVHDR
WHERE       project = @parm1 and
change_order_num = @parm2 and
status = 'P'
GO
