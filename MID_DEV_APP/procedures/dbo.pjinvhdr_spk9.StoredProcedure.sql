USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk9]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk9]   as
select * from pjinvhdr where draft_num = 'Z'
order by draft_num
GO
