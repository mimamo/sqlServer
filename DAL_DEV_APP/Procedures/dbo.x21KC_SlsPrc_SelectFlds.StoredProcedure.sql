USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_SlsPrc_SelectFlds]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_SlsPrc_SelectFlds]   @PriceCat varchar( 2), @DiscPrcTyp varchar( 1),@SelectFld1 varchar (30),@SelectFld2 varchar(30),
@CuryID varchar(4),@SiteID varchar(10)as
declare @numrecs int
SELECT @numrecs =  count(*) from slsprc where 
pricecat = @pricecat and DiscPrcTyp = @DiscPrcTyp and SelectFld1 = @SelectFld1 and  SelectFld2 = @SelectFld2 and @CuryID = CuryID and @SiteID = SiteID
if @numrecs >0  
    BEGIN
	delete from slsprc where
	pricecat = @pricecat and DiscPrcTyp = @DiscPrcTyp and  SelectFld1 = @SelectFld1 and  SelectFld2 = @SelectFld2 and @CuryID = CuryID and @SiteID = SiteID
    END
GO
