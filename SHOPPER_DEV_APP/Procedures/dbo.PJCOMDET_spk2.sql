USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMDET_spk2]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMDET_spk2] as
select * from PJCOMDET
where fiscalno = 'Z'
and system_cd = 'Z'
and batch_id = 'Z'
and detail_num = 9
GO
