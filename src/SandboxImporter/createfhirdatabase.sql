﻿
DROP PROCEDURE IF EXISTS dbo.UpsertResource

declare @sql varchar(max)=''

select @sql =@sql + 'drop table ' + name  + '; ' 
from sys.objects where type = 'U'

select @sql =@sql + 'drop type ' + name  + '; ' 
from sys.table_types


exec(@sql) 


/****** Object:  UserDefinedTableType [dbo].[DateSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[DateSearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[NumberSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[NumberSearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Number] [decimal](18, 6) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[QuantitySearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[QuantitySearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [nvarchar](256) NULL,
	[Code] [nvarchar](256) NULL,
	[Quantity] [decimal](18, 6) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ReferenceSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[ReferenceSearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[BaseUri] [varchar](512) NULL,
	[ReferenceResourceTypeId] [smallint] NULL,
	[ReferenceResourceId] [varchar](64) NOT NULL
)
GO


/****** Object:  UserDefinedTableType [dbo].[StringSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[StringSearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Value] [nvarchar](512) NOT NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TokenSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[TokenSearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [nvarchar](256) NULL,
	[Code] [nvarchar](256) NULL,
	[Text] [nvarchar](512) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UriSearchParamTableType]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE TYPE [dbo].[UriSearchParamTableType] AS TABLE(
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Uri] [varchar](256) NOT NULL
)
GO
GO
/****** Object:  Table [dbo].[Resource]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resource](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[Version] [int] NOT NULL,
	[LastUpdated] [datetime] NULL,
	[RawResource] [varbinary](max) NOT NULL)
GO

/****** Object:  Index [IX_Resource_Clustered]    Script Date: 3/25/2019 2:29:56 PM ******/
CREATE CLUSTERED INDEX [IXC_Resource] ON [dbo].[Resource]
(
	ResourceTypeId, 
	ResourceId, 
	Version
)

/****** Object:  Table [dbo].[DateSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DateSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO

CREATE CLUSTERED INDEX IXC_DateSearchParam ON [dbo].[DateSearchParam]
(
	SearchParamId,
	ResourceTypeId,
	ResourceId,
	CompositeInstanceId,
	StartTime,
	EndTime
)

/****** Object:  Table [dbo].[NumberSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NumberSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Number] [decimal](18, 6) NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX IXC_NumberSearchParam ON [dbo].[NumberSearchParam]
(
	SearchParamId,
	ResourceTypeId,
	ResourceId,
	CompositeInstanceId,
	Number
)

/****** Object:  Table [dbo].[QuantitySearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuantitySearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [varchar](128) NULL,
	[Code] [varchar](128) NULL,
	[Quantity] [decimal](18, 6) NOT NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

CREATE CLUSTERED INDEX IXC_QuantitySearchParam ON [dbo].[QuantitySearchParam]
(
	SearchParamId,
	ResourceTypeId,
	ResourceId,
	CompositeInstanceId,
	Quantity,
	Code,
	System
)
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE NONCLUSTERED INDEX IXC_TokenSearchParam_SearchParamId_Code_System ON [dbo].[QuantitySearchParam]
(
	SearchParamId,
	Quantity,
	Code,
	System
)
INCLUDE (ResourceTypeId, ResourceId, CompositeInstanceId)
WITH (DATA_COMPRESSION = PAGE)

/****** Object:  Table [dbo].[ReferenceSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReferenceSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[BaseUri] [varchar](128) NULL,
	[ReferenceResourceTypeId] [smallint] NULL,
	[ReferenceResourceId] [varchar](64) NOT NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

GO

CREATE CLUSTERED INDEX IXC_ReferenceSearchParam ON [dbo].[ReferenceSearchParam]
(
	SearchParamId,
	BaseUri,
	ReferenceResourceTypeId,
	ReferenceResourceId,
	ResourceTypeId
)

CREATE NONCLUSTERED INDEX IX_ReferenceSearchParam_SearchParamId_BaseUri_ResourceId
ON [dbo].[ReferenceSearchParam] ([SearchParamId],[ResourceId])
INCLUDE (BaseUri, ReferenceResourceTypeId, ReferenceResourceId)
with (DATA_COMPRESSION=PAGE)

GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceType](
	[ResourceTypeId] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [Id_ResourceType] PRIMARY KEY CLUSTERED 
(
	[ResourceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchParam](
	[SearchParamId] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[Uri] [varchar](128) NOT NULL,
	[ComponentIndex] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StringSearchParam]    Script Date: 3/25/2019 2:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StringSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE CLUSTERED INDEX IXC_StringSearchParam ON [dbo].[StringSearchParam]
(
	SearchParamId,
	ResourceTypeId,
	ResourceId,
	CompositeInstanceId,
	Value
)

/****** Object:  Table [dbo].[TokenSearchParam]    Script Date: 3/25/2019 2:29:57 PM ******/



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TokenSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[System] [varchar](256) NULL,
	[Code] [varchar](256) NULL,
	[Text] [nvarchar](512) NULL
) ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)
GO

CREATE CLUSTERED INDEX IXC_TokenSearchParam ON [dbo].[TokenSearchParam]
(
	SearchParamId,
	ResourceTypeId,
	ResourceId,
	Code,
	System,
	CompositeInstanceId
)

CREATE NONCLUSTERED INDEX IX_TokenSearchParam_SearchParamId_Code_System ON [dbo].[TokenSearchParam]
(
	SearchParamId,
	Code,
	System
)
INCLUDE (ResourceTypeId, ResourceId, CompositeInstanceId)
WITH (DATA_COMPRESSION = PAGE)

/****** Object:  Table [dbo].[TokenText]    Script Date: 3/25/2019 2:29:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UriSearchParam](
	[ResourceTypeId] [smallint] NOT NULL,
	[ResourceId] [varchar](64) NOT NULL,
	[SearchParamId] [smallint] NOT NULL,
	[CompositeInstanceId] [tinyint] NULL,
	[Uri] [varchar](256) NOT NULL
) 
ON [PRIMARY]
WITH (DATA_COMPRESSION = PAGE)

CREATE CLUSTERED INDEX IXC_UriSearchParam ON [dbo].[UriSearchParam]
(
	SearchParamId,
	ResourceTypeId,
	ResourceId,
	CompositeInstanceId,
	Uri
)


GO

CREATE NONCLUSTERED INDEX IX_StringSearchParam_ResourceTypeId_ResourceId ON StringSearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)
CREATE NONCLUSTERED INDEX IX_TokenSearchParam_ResourceTypeId_ResourceId ON TokenSearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)
CREATE NONCLUSTERED INDEX IX_DateSearchParam_ResourceTypeId_ResourceId ON DateSearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)
CREATE NONCLUSTERED INDEX IX_ReferenceSearchParam_ResourceTypeId_ResourceId ON ReferenceSearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)
CREATE NONCLUSTERED INDEX IX_QuantitySearchParam_ResourceTypeId_ResourceId ON QuantitySearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)
CREATE NONCLUSTERED INDEX IX_NumberSearchParam_ResourceTypeId_ResourceId ON NumberSearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)
CREATE NONCLUSTERED INDEX IX_UriSearchParam_ResourceTypeId_ResourceId ON UriSearchParam (ResourceTypeId, ResourceId) WITH (DATA_COMPRESSION = PAGE)

GO

CREATE PROCEDURE dbo.UpsertResource
	@resourceTypeId smallint,
	@resourceId varchar(64),
	@rawResource [varbinary](max),
	@tvpStringSearchParam [dbo].[StringSearchParamTableType] READONLY,
	@tvpTokenSearchParam [dbo].[TokenSearchParamTableType] READONLY,
	@tvpDateSearchParam [dbo].[DateSearchParamTableType] READONLY,
	@tvpReferenceSearchParam [dbo].[ReferenceSearchParamTableType] READONLY,
	@tvpQuantitySearchParam [dbo].[QuantitySearchParamTableType] READONLY,
	@tvpNumberSearchParam [dbo].[NumberSearchParamTableType] READONLY,
	@tvpUriSearchParam [dbo].[UriSearchParamTableType] READONLY
	AS
		SET XACT_ABORT ON
		BEGIN TRANSACTION

		DECLARE @version int = (SELECT (Version + 1) FROM dbo.Resource WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId)

		IF @version IS NULL BEGIN
			SET @version = 1
			INSERT INTO dbo.Resource 
			(ResourceTypeId, ResourceId, Version, LastUpdated, RawResource)
			VALUES (@resourceTypeId, @resourceId, @version, SYSUTCDATETIME(), @rawResource)
		END
		ELSE BEGIN 				 
			UPDATE dbo.Resource
			SET Version = @version, LastUpdated = SYSUTCDATETIME(), RawResource = @rawResource
			WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId

			DELETE FROM StringSearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
			DELETE FROM TokenSearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
			DELETE FROM DateSearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
			DELETE FROM ReferenceSearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
			DELETE FROM QuantitySearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
			DELETE FROM NumberSearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
			DELETE FROM UriSearchParam WHERE ResourceTypeId = @resourceTypeId AND ResourceId = @resourceId
		END

		INSERT INTO dbo.StringSearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, Value)
		SELECT @resourceTypeId, @resourceId, SearchParamId, CompositeInstanceId, Value FROM @tvpStringSearchParam

		INSERT INTO dbo.TokenSearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, System, Code, Text)
		SELECT @resourceTypeId, @resourceId, SearchParamId, CompositeInstanceId, System, Code, Text	 
		FROM @tvpTokenSearchParam

		INSERT INTO dbo.DateSearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, StartTime, EndTime)
		SELECT @resourceTypeId, @resourceId, SearchParamId, CompositeInstanceId, StartTime, EndTime FROM @tvpDateSearchParam

		INSERT INTO dbo.ReferenceSearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, BaseUri, ReferenceResourceTypeId, ReferenceResourceId)
		SELECT @resourceTypeId, @resourceId, p.SearchParamId, p.CompositeInstanceId, p.BaseUri, p.ReferenceResourceTypeId, p.ReferenceResourceId 
		FROM @tvpReferenceSearchParam p

		INSERT INTO dbo.QuantitySearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, System, Code, Quantity)
		SELECT @resourceTypeId, @resourceId, SearchParamId, CompositeInstanceId, System, Code, Quantity FROM @tvpQuantitySearchParam

		INSERT INTO dbo.NumberSearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, Number)
		SELECT @resourceTypeId, @resourceId, SearchParamId, CompositeInstanceId, Number FROM @tvpNumberSearchParam

		INSERT INTO dbo.UriSearchParam
		(ResourceTypeId, ResourceId, SearchParamId, CompositeInstanceId, Uri)
		SELECT @resourceTypeId, @resourceId, SearchParamId, CompositeInstanceId, Uri FROM @tvpUriSearchParam

		COMMIT TRANSACTION

		select @version
	GO

	dbcc shrinkfile(fhirsamplenk,1)
	dbcc shrinkfile(fhirsamplenk_log,1)