USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJALLAUD_Update]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xPJALLAUD_Update]
 @batnbr varchar(10)
as 

Update 
	pjallaud
set 
	recalc_flag = 'Y'
from 
	PJAllAud d join PJTrnsfr a on
    a.Origfiscalno = d.fiscalno and
    a.Origsystem_cd = d.system_cd and
    a.Origbatch_id = d.batch_id and
    a.Origdetail_num = d.detail_num 
Where
	a.batch_id = @batnbr
GO
