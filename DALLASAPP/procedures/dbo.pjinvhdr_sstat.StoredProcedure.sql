USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sstat]    Script Date: 12/21/2015 13:45:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sstat] as
select * from pjinvhdr where inv_status <> 'PO' and inv_status <> 'PR'
order by draft_num
GO
