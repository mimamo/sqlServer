USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDOC_sref]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[ARDOC_sref] @parm1 varchar (10) , @parm2 varchar (10)   as
select *
from  ARDOC
where ARDOC.batnbr =  @parm1 and
ARDOC.refnbr =  @parm2
GO
