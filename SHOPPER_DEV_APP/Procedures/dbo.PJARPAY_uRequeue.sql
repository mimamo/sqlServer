USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJARPAY_uRequeue]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJARPAY_uRequeue]  @parm1 varchar (6)  as
update PJARPAY
set status = '1'
from PJARPAY, ARDOC
where
PJARPAY.status =  '9' and
PJARPAY.check_refnbr = ARDOC.refnbr and
ARDOC.perpost = @parm1
GO
