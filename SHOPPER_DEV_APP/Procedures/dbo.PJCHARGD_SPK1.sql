USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGD_SPK1]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGD_SPK1]  @parm1 varchar (10)   as
select * from PJCHARGD
where    batch_id    = @parm1
order by batch_id,
detail_num
GO
