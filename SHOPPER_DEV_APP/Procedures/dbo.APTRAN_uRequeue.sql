USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTRAN_uRequeue]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[APTRAN_uRequeue]  @parm1 varchar (6)  as
update APTRAN
set pc_status = '1'
where
APTRAN.perpost =  @parm1  and
APTRAN.pc_status =  '9'
GO
