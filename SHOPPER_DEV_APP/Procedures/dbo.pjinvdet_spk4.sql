USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk4]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk4] @parm1 varchar (10)  as
select * from PJINVDET
where pjinvdet.draft_num =      @parm1
order by pjinvdet.acct
GO
