USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_sCount]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJREVHDR_sCount] @parm1 varchar (16) as
select count(*) from pjrevhdr
where
project like @parm1 and
revisiontype = 'cr' and
status in ('I','C','R')
GO
