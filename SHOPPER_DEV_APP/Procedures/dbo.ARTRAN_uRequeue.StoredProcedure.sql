USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTRAN_uRequeue]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARTRAN_uRequeue]  @parm1 varchar (6)  as
update ARTRAN
set pc_status = '1'
where
ARTRAN.perpost =  @parm1  and
ARTRAN.pc_status =  '9' and
ARTRAN.projectid <> '' and
ARTRAN.taskid <> ''
update ARTRAN
set pc_status = ' '
where
ARTRAN.perpost =  @parm1  and
ARTRAN.pc_status =  '9' and
ARTRAN.projectid = '' and
ARTRAN.taskid = ''
GO
