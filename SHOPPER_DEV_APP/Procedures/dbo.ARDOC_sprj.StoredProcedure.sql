USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_sprj]    Script Date: 12/21/2015 14:34:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_sprj] @parm1 varchar (16)   as
select docbal, docdate, doctype, refnbr, user1, user2, user4, rlsed,
bankacct, jobcntr
from  ARDOC
where ARDOC.projectid =  @parm1 and
ARDOC.rlsed =  1 and
ARDOC.docbal <> 0 and
(ARDOC.doctype = 'IN' or
ARDOC.doctype = 'FI' or
ARDOC.doctype = 'DM')
GO
