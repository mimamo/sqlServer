USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_AsmPlanDet]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_AsmPlanDet]   @invtid varchar(30),@planid varchar(6)   as      
select * from AsmPlanDet where 
invtid = @invtid
and planid = @planid
order by invtid
GO
