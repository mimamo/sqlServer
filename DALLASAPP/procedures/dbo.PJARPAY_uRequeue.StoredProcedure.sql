USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJARPAY_uRequeue]    Script Date: 12/21/2015 13:44:58 ******/
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
