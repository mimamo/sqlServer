USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOMDET_spk1]    Script Date: 12/21/2015 16:07:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOMDET_spk1]
as
select * from PJCOMDET
where fiscalno = 'Z'
and system_cd = 'Z'
and batch_id = 'Z'
and detail_num = 9
GO
