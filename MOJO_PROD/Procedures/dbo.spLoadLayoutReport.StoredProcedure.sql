USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spLoadLayoutReport]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spLoadLayoutReport]
    @CompanyKey int,
	
	@LayoutName varchar(500), -- get LayoutKey from LayoutName (and CompanyKey) 
	@Entity varchar(50),      -- get LayoutReportKey from Entity and LayoutKey

	@PaperType varchar(50),
	@PaperWidth smallint,
	@PaperHeight smallint,
	@PaperOrientation varchar(50),
	@MarginTop smallint,
	@MarginBottom smallint,
	@MarginLeft smallint,
	@MarginRight smallint,
	@Watermark image,
	@WatermarkSizeMode varchar(50),
	@WatermarkAlignment varchar(50)
AS --Encrypt

/*
|| When      Who Rel      What
|| 6/2/10    GHL 10.5.3.0 Added support of layouts to the load standard functionality
|| 12/21/10  RLB 10.539   (97402) only update report layout if the LayoutReportKey does not exist
*/

	DECLARE @LayoutKey INT
	DECLARE @LayoutReportKey INT
	DECLARE @Ret INT

	SELECT @LayoutKey = isnull(LayoutKey, 0) FROM tLayout (nolock) Where CompanyKey = @CompanyKey and LayoutName = @LayoutName

	SELECT @LayoutReportKey = ISNULL(LayoutReportKey, 0) FROM tLayoutReport (nolock) where LayoutKey = @LayoutKey and Entity = @Entity 

	if @LayoutKey > 0 AND @LayoutReportKey > 0
		return -1


	

	-- if not found, it is OK, we will create it

	-- if called several times, the report will be created as many times
	EXEC @Ret = sptLayoutReportUpdate @LayoutReportKey, @LayoutKey,
		@Entity,
		@PaperType ,
		@PaperWidth ,
		@PaperHeight ,
		@PaperOrientation,
		@MarginTop ,
		@MarginBottom ,
		@MarginLeft ,
		@MarginRight ,
		@Watermark,
		@WatermarkSizeMode ,
		@WatermarkAlignment 
	
	-- we will need the layout report key to insert sections and items
	RETURN @Ret
GO
